#include <iostream>
#include <memory>
#include <string>

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsim_top.h"

#include "task.h"

Task::Task(Vsim_top * top): top(top) {
    finished = false;

    cur_task_type = IDLE;
    cur_task_start_time = 0;
    cur_task_dur = 10;
    cur_task_wait_stop = 0;

    seq_file = fopen("test/task.seq", "r");
    if (!seq_file) {
        std::cerr << "WARNING: no sequence file!!!" << std::endl;
        finished = true;
    }
}

Task::~Task() {
    if (seq_file) {
        fclose(seq_file);
    }
}

bool Task::is_finished() {
    return finished;
}

void Task::check_done(long context_time) {
    long t_time = context_time - cur_task_start_time;

    if (t_time > cur_task_dur && (!cur_task_wait_stop || top->machine_is_stop)) {
        std::cout << "task done" << std::endl;
        get_new_task(context_time);
    }
}

void Task::do_task(long context_time) {
    if (finished) {
        return;
    }

    long t_time = context_time - cur_task_start_time;

    if (cur_task_type == IDLE) {

    } else if (cur_task_type == ARR_REG_C) {
        top->sw_allow_arr = 1;
        top->sw_arr_reg_c_value = cur_task_data[0];
        if (t_time > 128 && t_time < 135) {
            top->btn_do_arr_c = 1;
        } else {
            top->btn_do_arr_c = 0;
        }
    } else if (cur_task_type == ARR_STRT) {
        top->sw_allow_arr = 1;
        top->sw_arr_strt_value = cur_task_data[0];
        if (t_time > 128 && t_time < 135) {
            top->btn_do_arr_strt = 1;
        } else {
            top->btn_do_arr_strt = 0;
        }
    } else if (cur_task_type == ARR_SEL) {
        top->sw_allow_arr = 1;
        top->sw_arr_sel_value = cur_task_data[0];
        if (t_time > 128 && t_time < 135) {
            top->btn_do_arr_sel = 1;
        } else {
            top->btn_do_arr_sel = 0;
        }
    } else if (cur_task_type == CLEAR_STRT) {
        top->sw_allow_arr = 0;
        if (t_time > 3 && t_time < 8) {
            top->btn_do_arr_strt = 1;
        } else {
            top->btn_do_arr_strt = 0;
        }
    } else if (cur_task_type == START_PULSE) {
        if (t_time > 1 && t_time < 6) {
            top->btn_start_pulse = 1;
        } else {
            top->btn_start_pulse = 0;
        }
    } else if (cur_task_type == CLEAR_PULSE) {
        if (t_time > 1 && t_time < 6) {
            top->btn_clear_pu = 1;
        } else {
            top->btn_clear_pu = 0;
        }
    } else if (cur_task_type == MEM_READ) {
        if (t_time > 1 && t_time < 6) {
            top->btn_mem_read = 1;
        } else {
            top->btn_mem_read = 0;
        }
    } else if (cur_task_type == MEM_WRITE) {
        if (t_time > 1 && t_time < 6) {
            top->btn_mem_write = 1;
        } else {
            top->btn_mem_write = 0;
        }
    } else if (cur_task_type == START_INPUT) {
        if (t_time > 1 && t_time < 6) {
            top->btn_start_input = 1;
        } else {
            top->btn_start_input = 0;
        }
    } else if (cur_task_type == STOP_INPUT) {
        if (t_time > 1 && t_time < 6) {
            top->btn_stop_input = 1;
        } else {
            top->btn_stop_input = 0;
        }
    } else if (cur_task_type == START_OUTPUT) {
        if (t_time > 1 && t_time < 6) {
            top->btn_start_output = 1;
        } else {
            top->btn_start_output = 0;
        }
    } else if (cur_task_type == STOP_OUTPUT) {
        if (t_time > 1 && t_time < 6) {
            top->btn_stop_output = 1;
        } else {
            top->btn_stop_output = 0;
        }
    } else if (cur_task_type == SET_IO_SW) {
        top->sw_input_dec = cur_task_data[0];
        top->sw_output_dec = cur_task_data[1];
        top->sw_continuous_input = cur_task_data[2];
        top->sw_stop_after_output = cur_task_data[3];
    } else if (cur_task_type == SET_MAIN_SW) {
        top->sw_automatic = cur_task_data[0];
    }

    // std::cout << "doing task: " << cur_task_type << std::endl;
}

void Task::get_new_task(long context_time) {
    static char buffer[21];
    int res = fscanf(seq_file, "%20s", buffer);
    if (res != 1) {
        finished = true;
        return;
    }

    std::string type_name = buffer;
    int temp1, temp2, temp3, temp4;
    if (type_name == "idle") {
        cur_task_type = IDLE;
        cur_task_data.clear();

    } else if (type_name == "arr_reg_c") {
        cur_task_type = ARR_REG_C;
        cur_task_data.clear();
        res = fscanf(seq_file, "%o", &temp1);
        if (res != 1) {
            finished = true;
            return;
        }
        cur_task_data.push_back(temp1);

    } else if (type_name == "arr_strt") {
        cur_task_type = ARR_STRT;
        cur_task_data.clear();
        res = fscanf(seq_file, "%o", &temp1);
        if (res != 1) {
            finished = true;
            return;
        }
        cur_task_data.push_back(temp1);
        
    } else if (type_name == "arr_sel") {
        cur_task_type = ARR_SEL;
        cur_task_data.clear();
        res = fscanf(seq_file, "%o", &temp1);
        if (res != 1) {
            finished = true;
            return;
        }
        cur_task_data.push_back(temp1);

    } else if (type_name == "clear_strt") {
        cur_task_type = CLEAR_STRT;

    } else if (type_name == "start_pulse") {
        cur_task_type = START_PULSE;

    } else if (type_name == "clear_pulse") {
        cur_task_type = CLEAR_PULSE;
        
    } else if (type_name == "mem_read") {
        cur_task_type = MEM_READ;

    } else if (type_name == "mem_write") {
        cur_task_type = MEM_WRITE;
        
    } else if (type_name == "start_input") {
        cur_task_type = START_INPUT;

    } else if (type_name == "stop_input") {
        cur_task_type = STOP_INPUT;

    } else if (type_name == "start_output") {
        cur_task_type = START_OUTPUT;

    } else if (type_name == "stop_output") {
        cur_task_type = STOP_OUTPUT;

    } else if (type_name == "set_io_sw") {
        cur_task_type = SET_IO_SW;
        cur_task_data.clear();
        res = fscanf(seq_file, "%d%d%d%d", &temp1, &temp2, &temp3, &temp4);
        if (res != 4) {
            finished = true;
            return;
        }
        cur_task_data.push_back(temp1);
        cur_task_data.push_back(temp2);
        cur_task_data.push_back(temp3);
        cur_task_data.push_back(temp4);

    } else if (type_name == "set_main_sw") {
        cur_task_type = SET_MAIN_SW;
        cur_task_data.clear();
        res = fscanf(seq_file, "%d", &temp1);
        if (res != 1) {
            finished = true;
            return;
        }
        cur_task_data.push_back(temp1);

    }
    res = fscanf(seq_file, "%ld%d", &cur_task_dur, &temp1);
    cur_task_wait_stop = temp1 ? true : false;
    if (res != 2) {
        finished = true;
        return;
    }

    std::cout << "get task: " << type_name << std::endl;
    // std::cout << "now task: " << cur_task_type << std::endl;

    cur_task_start_time = context_time;
}
