printf "FNDSA_JSON_BEGIN\n"
printf "{\"state\":%u,\"error\":%u,\"profile_error\":%u,", fndsa_bench_state, fndsa_bench_error, fndsa_profile_error
printf "\"core_clock_hz\":%u,\"cpuid\":%u,\"device_id\":%u,", fndsa_bench_core_clock_hz, fndsa_bench_cpuid, fndsa_bench_device_id
printf "\"cache_control\":%u,\"fingerprint\":%u,\"operations\":[", fndsa_bench_cache_control, fndsa_bench_fingerprint
set $op = 0
while $op < 3
  if $op > 0
    printf ","
  end
  printf "{\"calls\":%u,\"total_cycles\":%llu,", fndsa_profile_stats[$op].calls, fndsa_profile_stats[$op].total
  printf "\"minimum_cycles\":%llu,\"maximum_cycles\":%llu,\"cycles\":[", fndsa_profile_stats[$op].minimum, fndsa_profile_stats[$op].maximum
  set $cat = 0
  while $cat < 21
    if $cat > 0
      printf ","
    end
    printf "%llu", fndsa_profile_stats[$op].ticks[$cat]
    set $cat = $cat + 1
  end
  printf "],\"entries\":["
  set $cat = 0
  while $cat < 21
    if $cat > 0
      printf ","
    end
    printf "%u", fndsa_profile_stats[$op].entries[$cat]
    set $cat = $cat + 1
  end
  printf "]}"
  set $op = $op + 1
end
printf "]}\nFNDSA_JSON_END\n"
