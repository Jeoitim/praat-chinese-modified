form Compatibility test
    sentence output_file ../../build/integrated-test.txt
endform
writeFileLine: output_file$, "Praat Chinese integrated compatibility tests"
assert fileReadable(applicationDirectory$ + "/assets/legacy/a.praat")
assert fileReadable(applicationDirectory$ + "/assets/legacy/by.praat")
assert index(preferencesDirectory$, "Praat") <> 0 or index(preferencesDirectory$, "prefs") <> 0
Create Sound from formula: "test", 1, 0, 0.1, 22050, "0.5*sin(2*pi*200*x)"
n = Bei 幅度积1
a = Bei 幅度积2: 0, 2
b = Bei 幅度积3: 0.5
assert n = 2205
assert abs(a - 0.04269071714781779) < 1e-12
assert b = 16384
To Spectrum: "yes"
bin = Bei Spectrum2: 205
db = Bei 功率谱分贝值: 2
assert abs(bin - 39.080725623582765) < 1e-10
assert abs(db - 42.260331947753556) < 1e-9
energy$ = Bei 计算能量分布模式: 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
assert energy$ = "13.00" + tab$ + "6.63"
energy$ = Bei 计算能量分布模式: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
assert energy$ = "20.25" + tab$ + "4.01"
energy$ = Bei 计算能量分布模式: 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
assert energy$ = "12.88" + tab$ + "6.70"
sk = Bei 计算偏度: 10, 20, 30
ku = Bei 计算峰度: 10, 20, 30
se = Bei 计算偏度的标准误: 10
ke = Bei 计算峰度的标准误: 10
jb = Bei 计算Jarque-Bera值: 10, 0.5, 3
assert abs(sk - 1.2577882373436315) < 1e-12
assert abs(ku + 3.0133928571428577) < 1e-12
assert abs(se - 0.6870429186215167) < 1e-12
assert abs(ke - 1.334248769989982) < 1e-12
assert abs(jb - 4.166666666666667) < 1e-12
st = Bei 根据赫兹按指定参考频率求半音: 200, 100
hz = Bei 根据半音按指定参考频率求赫兹: 12, 100
assert st = 12
assert hz = 200
Bei 修改0
re = Get real value in bin: 1
im = Get imaginary value in bin: 1
assert re = 0 and im = 0
Remove
select Sound test
Save as WAV file: output_file$ + ".wav"
Remove
Read from file: output_file$ + ".wav"
duration = Get total duration
assert abs(duration - 0.1) < 1e-12
To Pitch: 0.01, 75, 500
pitch = Get mean: 0, 0, "Hertz"
assert abs(pitch - 200) < 0.5
appendFileLine: output_file$, "PASS: exact legacy numeric compatibility, bundled resources, Sound/WAV/Pitch"
runScript: applicationDirectory$ + "/assets/legacy/by.praat"
appendFileLine: output_file$, "PASS: supplied replacement tone diagram script"
