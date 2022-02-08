#include <iostream>
#include <memory>

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsim_top.h"

#include "task.h"

int main(int argc, char** argv, char** env) {

    // Prevent unused variable warnings
    if (false && argc && argv && env) {}

    // Create logs/ directory in case we have traces to put under it
    Verilated::mkdir("logs");

    // Construct context class
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    // Construct the Verilated model
    const std::unique_ptr<Vsim_top> top{new Vsim_top{contextp.get(), "TOP"}};
    // Construct trace save object
    const std::unique_ptr<VerilatedVcdC> trace_p{new VerilatedVcdC};

    // Set debug level, 0 is off, 9 is highest presently used
    contextp->debug(0);

    // Randomization reset policy
    contextp->randReset(2);

    // Verilator must compute traced signals
    contextp->traceEverOn(true);
    top->trace(trace_p.get(), 99);
    trace_p->open("logs/vlt_dump.vcd");

    contextp->commandArgs(argc, argv);

    // inital value of signals
    top->resetn = !0;
    top->clk = 0;

    top->btn_start_pulse = 0;
    top->btn_clear_pu = 0;
    top->btn_mem_read = 0;
    top->btn_mem_write = 0;
    top->btn_start_input = 0;
    top->btn_stop_input = 0;
    top->btn_start_output = 0;
    top->btn_stop_output = 0;
    top->sw_input_dec = 0;
    top->sw_output_dec = 0;
    top->sw_continuous_input = 0;
    top->sw_stop_after_output = 0;
    top->sw_automatic = 0;
    top->sw_stop_at_cmp = 0;
    top->sw_cmp_with_strt = 0;
    top->sw_allow_arr = 0;
    top->btn_do_arr_c = 0;
    top->btn_do_arr_strt = 0;
    top->btn_do_arr_sel = 0;

    // initial task
    const std::unique_ptr<Task> task_p{new Task(top.get())};

    // Simulate until $finish
    while (!contextp->gotFinish() && !task_p->is_finished()) {

        contextp->timeInc(1);  // 1 timeprecision period passes...

        top->clk = !top->clk;
        
        // reset
        if (contextp->time() > 1 && contextp->time() < 8) {
            top->resetn = !1;  // Assert reset
        } else {
            top->resetn = !0;  // Deassert reset
        }

        if (!top->clk) {        // do operation at negedge
            task_p->check_done(contextp->time());
            task_p->do_task(contextp->time());
        }

        if (contextp->time() % 100000 == 0) {
            std::cout << "==== cur_time: " << contextp->time() << std::endl;
        }

        // Evaluate model
        top->eval();
        trace_p->dump(contextp->time());
    }
    
    // Coverage analysis (calling write only after the test is known to pass)
    contextp->coveragep()->write("logs/coverage.dat");

    // Final model cleanup
    top->final();
    trace_p->close();

    return 0;
}
