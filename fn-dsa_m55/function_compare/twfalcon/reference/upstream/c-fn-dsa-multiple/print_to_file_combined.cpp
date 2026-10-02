/*
 * Copyright 2025 NXP
 * SPDX-License-Identifier: MIT
 */

#include "print_to_file_combined.h"
#include <algorithm>
#include <mutex>
#include <string.h>
#include <string>
#include <thread>
#include <unistd.h>
#include <unordered_map>
// #include "print_to_file.h"

// enum type { add, mul, sqrt, divv };
// #include <unordered_map>

// extern "C" void get_file_name(char time_str[30]);

#define THREAD_ITEM_LIST_SIZE 1000000000

using InnerMap = std::unordered_map<int16_t, uint64_t>;

typedef struct {
    // pid_t id;
    int i;
    struct item {
        type operation;
        uint16_t exponent;
    } items[THREAD_ITEM_LIST_SIZE];
} thread_local_list;

typedef struct {
    // pid_t id;
    int i;
    InnerMap map[5];
} thread_local_map;

thread_local thread_local_map local_map;

class ExponentFprValues {
  private:
    std::unordered_map<std::string, InnerMap> map;
    InnerMap map_combined[5];
    std::mutex mtx;

  public:
    void addItem(const enum type operation, const int16_t exponent) {

        local_map.map[operation][exponent] += 1;
        local_map.i += 1;

        if (local_map.i < THREAD_ITEM_LIST_SIZE) {
            return;
        }
        local_map.i = 0;

        combine();
    }


    void writeToFile(char fileName[30]) {
        FILE *fptr = fopen(fileName, "w");
        fprintf(fptr, "operation,exponent,count\n");

        for (int operation = 0; operation < 5; operation++) {
            for (auto [exponent, count] : map_combined[operation]) {
                fprintf(fptr, "%d,%d,%lu\n", operation, exponent, count);
            }
        }
        fclose(fptr);
    }

    void combine(){

        mtx.lock();

        printf("start writing\n");

        for (int operation = 0; operation < 5; operation++) {
            for (auto [exponent, count] : local_map.map[operation]) {

                map_combined[operation][exponent] += count;
            }
        }

        mtx.unlock();
    }
};

static ExponentFprValues exponentFprMap;

extern "C" {
void add_item_c(const enum type operation, const int16_t exponent) {
    exponentFprMap.addItem(operation, exponent);
}

void write_to_file(char file_name[30]) {
    exponentFprMap.writeToFile(file_name);
}
void combine(){
    exponentFprMap.combine();
}

}
