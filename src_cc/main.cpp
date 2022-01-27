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
    // "VerilatedContext* contextp = new VerilatedContext" then deleting at end.
    const std::unique_ptr<VerilatedContext> context_p{new VerilatedContext};

    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v".
    // Using unique_ptr is similar to "Vtop* top = new Vtop" then deleting at end.
    // "TOP" will be the hierarchical name of the module.
    const std::unique_ptr<Vsim_top> top{new Vsim_top{context_p.get(), "TOP"}};

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs argument parsing
    context_p->debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs argument parsing
    context_p->randReset(2);

    // Verilator must compute traced signals
    context_p->traceEverOn(true);
    VerilatedVcdC * trace_p = new VerilatedVcdC;
    top->trace(trace_p, 99);
    trace_p->open("logs/vlt_dump.vcd");

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    context_p->commandArgs(argc, argv);

    top->resetn = !0;
    top->clk = 0;

    // Simulate until $finish
    while (!context_p->gotFinish() && context_p->time() < 50) {
        // Historical note, before Verilator 4.200 Verilated::gotFinish()
        // was used above in place of contextp->gotFinish().
        // Most of the contextp-> calls can use Verilated:: calls instead;
        // the Verilated:: versions simply assume there's a single context
        // being used (per thread).  It's faster and clearer to use the
        // newer contextp-> versions.

        context_p->timeInc(1);  // 1 timeprecision period passes...
        // Historical note, before Verilator 4.200 a sc_time_stamp()
        // function was required instead of using timeInc.  Once timeInc()
        // is called (with non-zero), the Verilated libraries assume the
        // new API, and sc_time_stamp() will no longer work.

        // Toggle a fast (time/2 period) clock
        top->clk = !top->clk;

        // Toggle control signals on an edge that doesn't correspond
        // to where the controls are sampled; in this example we do
        // this only on a negedge of clk, because we know
        // reset is not sampled there.
        if (!top->clk) {
            if (context_p->time() > 1 && context_p->time() < 10) {
                top->resetn = !1;  // Assert reset
            } else {
                top->resetn = !0;  // Deassert reset
            }
        }

        std::cout << context_p->time() << std::endl;

        // Evaluate model
        top->eval();
        trace_p->dump(context_p->time());
    }

    // Final model cleanup
    top->final();
    trace_p->close();

    delete trace_p;
    return 0;
}
