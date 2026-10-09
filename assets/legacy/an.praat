legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
form set parameters
	positive herzt 100
	positive reference_frequency 50
endform
clearinfo
semitone = Bei 根据赫兹按指定参考频率求半音... herzt reference_frequency
printline 'semitone'