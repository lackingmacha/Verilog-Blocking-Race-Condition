# Verilog Race Condition: Blocking (=) vs. Non-Blocking (<=)

This repository explores a classic synchronization trap in Verilog RTL design. I implemented a simple 2-stage register logic in **Vivado** to demonstrate how coding style directly impacts simulation determinism and hardware synthesis.

## 🔍 The Problem Statement
The goal was to create a 2-stage shift register using two separate \`always\` blocks:

\`\`\`verilog
// Blocking Version (The "Race" Case)
always @(posedge clk) q1 = a; 
always @(posedge clk) q2 = q1;
\`\`\`

## 🤖 AI vs. Reality
When I cross-checked this logic with **Claude AI**, the model suggested it would logically form a shift register. However, theory and practice diverged in the simulator. 

By implementing this in **Vivado (XSIM)**, I discovered that the shift register behavior completely vanished in the blocking version. Because both blocks trigger on the same clock edge, the simulator's event queue executed them sequentially, causing \`q2\` to "race ahead" and capture the *new* value of \`q1\` in the same cycle.

## 📊 Simulation Results (Vivado)
The waveform below clearly shows the difference:

![Vivado Waveform](./waveform_result.png)

| Assignment Type | Behavior Observed | Hardware Intent |
| :--- | :--- | :--- |
| **Blocking (=)** | \`q1\` and \`q2\` update simultaneously | **FAILED** (Acts like a single wire/buffer) |
| **Non-Blocking (<=)** | \`q2\` lags \`q1\` by 1 clock cycle | **SUCCESS** (Correct Shift Register) |

## 💡 Key Takeaways
1. **Simulation Determinism:** In a simulator, the execution order of multiple \`always\` blocks at the same time step is undefined. 
2. **The Golden Rule:** 
   - Use **Non-Blocking (<=)** for all sequential logic (Flip-Flops).
   - Use **Blocking (=)** only for combinational logic.
3. **Verify Everything:** Don't rely solely on AI or textbooks—always verify your RTL with a professional simulator like Vivado.

## 🛠️ How to Use
1. Clone the repo.
2. Add \`blocking_race.v\`, \`non_blocking_correct.v\`, and \`tb_race.v\` to your Vivado project.
3. Run Behavioral Simulation to reproduce the results.
