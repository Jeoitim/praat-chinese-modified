form GUI test
    sentence output_file ../../build/gui-test.txt
endform
writeFileLine: output_file$, "GUI compatibility test started"
Create Sound from formula: "gui_validation", 1, 0, 0.5, 22050, "0.5*sin(2*pi*200*x)"
View & Edit
editor Sound gui_validation
Show analyses: "yes", "yes", "yes", "yes", "yes", 10
Select: 0.1, 0.3
pitch$ = H测量基频
assert length(pitch$) > 20
assert index(pitch$, "undefined") = 0
appendFileLine: output_file$, "PASS: H pitch output ", pitch$
Move cursor to: 0.2
formants$ = H测量共振峰
assert length(formants$) > 0
appendFileLine: output_file$, "PASS: H formants output ", formants$
Select: 0.1, 0.3
formants10$ = H测量共振峰(10点)
assert length(formants10$) > 30
appendFileLine: output_file$, "PASS: H 10-point formants output"
endeditor
select Sound gui_validation
To Pitch: 0.01, 75, 500
Down to PitchTier
View & Edit
editor PitchTier gui_validation
Select: 0.1, 0.3
endeditor
appendFileLine: output_file$, "PASS: SoundEditor and PitchTierEditor bundled menus created"

select Sound gui_validation
Go to manual page: "Intro"
appendFileLine: output_file$, "PASS: Chinese manual opened"
About PraatChineseModified
