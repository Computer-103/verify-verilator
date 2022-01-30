#ifndef TASK_H_
#define TASK_H_

#include <vector>
#include "Vsim_top.h"

enum task_type {
    IDLE,
    ARR_REG_C,
    ARR_STRT,
    CLEAR_STRT,
    ARR_SEL,
    START_PULSE,
    CLEAR_PULSE,
    START_INPUT,
    STOP_INPUT,
    START_OUTPUT,
    STOP_OUTPUT,
    SET_IO_SW,
    SET_MAIN_SW,
};

class Task {
private:
    Vsim_top * top;
    FILE * seq_file;
    bool finished;
    
    task_type cur_task_type;
    std::vector<int> cur_task_data;

    long cur_task_start_time;
    long cur_task_dur;
    bool cur_task_wait_stop;

    void get_new_task(long context_time);

public:
    Task(Vsim_top * top);
    ~Task();
    bool is_finished();
    void check_done(long context_time);
    void do_task(long context_time);
};

#endif
