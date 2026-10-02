/* Untimed differential checks. Included in both firmware variants. */
static int stream_edges(void)
{
    const unsigned policies[] = {0,1,2,7};
    const size_t lengths[] = {0,1,135,136,137,271,272,319};
    uint8_t input[4][320], got[211], want[211];
    unsigned checks = 0;
    for(unsigned l=0;l<4;l++)for(unsigned j=0;j<320;j++)
        input[l][j]=(uint8_t)(17*j+43*l);
    for(unsigned p=0;p<4;p++)for(unsigned t=0;t<8;t++) {
        fndsa_shake4_stream s;
        shake_context ref[4];
        fndsa_shake_iov v[4][3];const fndsa_shake_iov *vp[4];
        size_t counts[4]={3,3,3,3};
        for(unsigned l=0;l<4;l++) {
            size_t n=lengths[(t+l)%8],cut=n<7?n:7;
            v[l][0]=(fndsa_shake_iov){input[l],cut};
            v[l][1]=(fndsa_shake_iov){NULL,0};
            v[l][2]=(fndsa_shake_iov){input[l]+cut,n-cut};vp[l]=v[l];
            shake_init(&ref[l],256);shake_inject(&ref[l],input[l],n);shake_flip(&ref[l]);
        }
        fndsa_shake4_stream_init(&s,vp,counts,work.data,policies[p]);
        /* Asymmetric demands, then one request entirely ahead of the others. */
        for(unsigned r=0;r<48;r++)for(unsigned l=0;l<4;l++) {
            size_t len=1+(r*31+l*67)%211;
            fndsa_shake4_stream_read(&s,l,got,len);shake_extract(&ref[l],want,len);
            REQUIRE(!memcmp(got,want,len),401);checks++;
        }
        for(unsigned r=0;r<20;r++) {
            fndsa_shake4_stream_read(&s,0,got,sizeof got);
            shake_extract(&ref[0],want,sizeof want);
            REQUIRE(!memcmp(got,want,sizeof got),402);checks++;
        }
        for(uint8_t counter=1;counter<27;counter++) {
            unsigned lane=counter%4;
            fndsa_shake_iov retry[2]={{input[lane],40},{&counter,1}};
            fndsa_shake4_stream_reset_lane(&s,lane,retry,2);
            shake_init(&ref[lane],256);shake_inject(&ref[lane],input[lane],40);
            shake_inject(&ref[lane],&counter,1);shake_flip(&ref[lane]);
            for(unsigned l=0;l<4;l++) {
                fndsa_shake4_stream_read(&s,l,got,sizeof got);
                shake_extract(&ref[l],want,sizeof want);
                REQUIRE(!memcmp(got,want,sizeof got),403);checks++;
            }
        }
        REQUIRE(guards(),404);
    }
    printf("EDGE_STREAM checks=%u policies=0,1,2,7 unequal=PASS tails=PASS retry_1_26=PASS\n",checks);
    return 0;
}

#if PROFILE_KEYGEN
static int operation_edges(void)
{
    fndsa_keygen_batch4_job jobs[4];
    for(unsigned l=0;l<4;l++) {
        unsigned ln=9+(l&1);
        for(unsigned j=0;j<80;j++)seeds[l][j]=(uint8_t)(j*31+l*19);
        jobs[l]=(fndsa_keygen_batch4_job){ln,seeds[l],l?32:0,
            sk[l],FNDSA_SIGN_KEY_SIZE(ln),pk[l],FNDSA_VRFY_KEY_SIZE(ln)};
        REQUIRE(baseline_keygen_seeded_temp(ln,seeds[l],jobs[l].seed_len,
            original_sk[l],original_pk[l],work.data,sizeof work.data),410);
    }
    for(unsigned policy=0;policy<3;policy++) {
        REQUIRE(fndsa_keygen_seeded_batch4_temp(jobs,policy,work.data,sizeof work.data),411);
        for(unsigned l=0;l<4;l++) {
            REQUIRE(!memcmp(sk[l],original_sk[l],jobs[l].sign_key_len),412);
            REQUIRE(!memcmp(pk[l],original_pk[l],jobs[l].vrfy_key_len),413);
        }
    }
    /* Optional outputs, with differing completion/rejection counts. */
    jobs[0].sign_key=NULL;jobs[1].vrfy_key=NULL;
    jobs[2].sign_key=NULL;jobs[2].vrfy_key=NULL;
    REQUIRE(fndsa_keygen_seeded_batch4_temp(jobs,1,work.data,sizeof work.data),414);
    REQUIRE(!memcmp(pk[0],original_pk[0],jobs[0].vrfy_key_len),415);
    REQUIRE(!memcmp(sk[1],original_sk[1],jobs[1].sign_key_len),416);
    REQUIRE(!memcmp(sk[3],original_sk[3],jobs[3].sign_key_len),417);
    REQUIRE(!memcmp(pk[3],original_pk[3],jobs[3].vrfy_key_len),418);
    REQUIRE(!fndsa_keygen_seeded_batch4_temp(jobs,129,work.data,sizeof work.data),419);
    REQUIRE(!fndsa_keygen_seeded_batch4_temp(jobs,1,work.data,1),420);
    printf("EDGE_KEY mixed_degrees=PASS policies=0,1,2 optional_outputs=PASS invalid=PASS\n");
    return 0;
}
#else
static int operation_edges(void)
{
    const unsigned policies[]={0,1,7,SIGN_BLOCKS};
    uint8_t context[255];memset(context,0x63,sizeof context);
    unsigned checked=0,verified=0;
    for(unsigned p=0;p<4;p++) {
        fndsa_sign_batch4_job jobs[4];fndsa_verify_batch4_job verify[4];
        for(unsigned l=0;l<4;l++) {
            unsigned d=l&1,ln=9+d;
            for(unsigned j=0;j<80;j++) {
                seeds[l][j]=(uint8_t)(11*j+l*29+p);
                messages[l][j]=(uint8_t)(7*j+l*13+p);
            }
            const char *id=l==1?FNDSA_HASH_ID_SHA256:l==2?FNDSA_HASH_ID_EXTMU:FNDSA_HASH_ID_RAW;
            size_t ml=l==2?64:l==1?32:80;
            jobs[l]=(fndsa_sign_batch4_job){.sign_key=sks[d][l],.sign_key_len=FNDSA_SIGN_KEY_SIZE(ln),
                .ctx=context,.ctx_len=l==3?255:0,.id=id,.hv=messages[l],.hv_len=ml,
                .seed=seeds[l],.seed_len=l?80:0,.sig=sig[l],.max_sig_len=FNDSA_SIGNATURE_SIZE(ln)};
            fndsa_sign_batch4_job *j=&jobs[l];
            REQUIRE(reference_fndsa_sign_seeded_temp(j->sign_key,j->sign_key_len,j->ctx,j->ctx_len,
                j->id,j->hv,j->hv_len,j->seed,j->seed_len,original_sig[l],j->max_sig_len,
                work.data,sizeof work.data)==j->max_sig_len,430);
            verify[l]=(fndsa_verify_batch4_job){sig[l],j->max_sig_len,pks[d][l],FNDSA_VRFY_KEY_SIZE(ln),
                j->ctx,j->ctx_len,j->id,j->hv,j->hv_len,0};
        }
        REQUIRE(fndsa_sign_seeded_batch4_temp(jobs,policies[p],work.data,sizeof work.data),431);
        for(unsigned l=0;l<4;l++) {
            REQUIRE(jobs[l].sig_len==jobs[l].max_sig_len,432);
            REQUIRE(!memcmp(sig[l],original_sig[l],jobs[l].sig_len),433);checked++;
        }
        profile_watch_begin();
        int ok=fndsa_verify_batch4_temp(verify,work.data,sizeof work.data);
        unsigned singles=profile_watch_end();
        REQUIRE(ok&&!singles,434);
        for(unsigned l=0;l<4;l++){REQUIRE(verify[l].valid,435);verified++;}
        for(unsigned l=0;l<4;l++) {
            sig[l][jobs[l].sig_len-1]^=1;
            REQUIRE(fndsa_verify_batch4_temp(verify,work.data,sizeof work.data),436);
            for(unsigned k=0;k<4;k++)REQUIRE(verify[k].valid==(k!=l),437);
            sig[l][jobs[l].sig_len-1]^=1;
        }
        REQUIRE(guards(),438);
    }
    printf("EDGE_SIGN byte_exact=%u batch_verified=%u mixed_degrees=PASS domains=PASS lane_isolation=PASS\n",checked,verified);
    return 0;
}
#endif
