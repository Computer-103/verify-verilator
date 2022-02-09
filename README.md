# 103 机 SoC 及仿真框架

## 目录结构
```
.
├── Makefile    # 工程主 Makefile 文件
├── logs        # Verilator 工作目录 (不包含于 Git 仓库)
├── obj_dir     # Verilator 工作目录 (不包含于 Git 仓库)
├── obj.mk      # 构建脚本补充
├── input.vc    # 构建脚本补充参数
├── README.md   # 本文档
├── src_hw      # 硬件设计源码，Verilog HDL
├── src_tb      # 验证测试台，Verilog HDL
├── src_cc      # Verilator 仿真程序，C++
├── test        # 测试文件存放目录，需手动放置
│   ├── input.bin
│   ├── output.bin
│   └── task.seq
└── wave.gtkw   # Gtkwave 波型配置文件 (不包含于 Git 仓库)
```

## 仿真
将仓库克隆到本地，并获取子模块：
```
git clone --recurse-submodules git@github.com:Computer-103/verify-verilator.git
```

从 [Computer-103/test-program](https://github.com/Computer-103/test-program) 获取测试程序 `input.bin` 和 `task.seq`，放置于 `test/` 目录下。

编译、链接、运行，一气呵成：
```
make
```

使用 `md5sum` 检查输出结果是否与参考结果一致：
```
md5sum test/output.bin
```

