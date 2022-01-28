#include <iostream>
#include <memory>

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsim_top.h"

int main(int argc, char** argv, char** env) {

    // Prevent unused variable warnings
    if (false && argc && argv && env) {}

    // Create logs/ directory in case we have traces to put under it
    Verilated::mkdir("logs");

    // Using unique_ptr is similar to
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v".
    const std::unique_ptr<Vsim_top> top{new Vsim_top{contextp.get(), "TOP"}};

    // Set debug level, 0 is off, 9 is highest presently used
    contextp->debug(0);

    // Randomization reset policy
    contextp->randReset(2);

    // Verilator must compute traced signals
    contextp->traceEverOn(true);
    VerilatedVcdC * trace_p = new VerilatedVcdC;
    top->trace(trace_p, 99);
    trace_p->open("logs/vlt_dump.vcd");

    contextp->commandArgs(argc, argv);

    top->resetn = !0;
    top->clk = 0;

    long sim_time = 1000000;
    long base_time = 0;

    // Simulate until $finish
    while (!contextp->gotFinish()) {

        contextp->timeInc(1);  // 1 timeprecision period passes...

        top->clk = !top->clk;

        if (!top->clk) {        // do operation at negedge
            // set reset
            if (contextp->time() > 1 && contextp->time() < 10) {
                top->resetn = !1;  // Assert reset
            } else {
                top->resetn = !0;  // Deassert reset
            }
            
            // set start input
            if (contextp->time() > 16 && contextp->time() < 20) {
                top->btn_start_input = 1;
            } else {
                top->btn_start_input = 0;
            }

            if (top->machine_is_stop) {
                break;
            }
        }
        if (contextp->time() % 10000 == 0) {
            std::cout << contextp->time() << std::endl;
        }

        // Evaluate model
        top->eval();
        trace_p->dump(contextp->time());
    }

    // Final model cleanup
    top->final();
    trace_p->close();

    delete trace_p;
    return 0;
}
