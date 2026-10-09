legacyResourceDirectory$ = applicationDirectory$ + "/assets/legacy"
legacyDataDirectory$ = dataDirectory$
#本脚本由贝先明编写，经由praat汉化修改版测试通过。
#本脚本的功能是输入praat国际音标输入代码表。
#请勿在其他praat软件上运行本脚本，因为有的语句是praat汉化修改版独有的。
#2019.10.06

clearinfo
printline IPA
printline =========
printline ɸ:\ff	ɿ:\id	tʰ:t\^h aspiration
printline β:\bf	ʅ:\ir	bʱ:b\^H voiced aspiration (breathiness)
printline ʙ:\bc	ɨ:\i-	tʲ:t\^j palatalization
printline ɓ:\b^	ʉ:\u-	tˠ:t\^g, tᵚ t\^M, tᶭ t\^G velarization
printline ɱ:\mj	ɯ:\mt	kʷ:k\^w rounding
printline ʋ:\vs	ɪ:\ic	tᶣ:t\^Y rounding with palatalization
printline θ:\tf	ʏ:\yc	aˀ:a\^? glottalization
printline ð:\dh	ʊ:\hs	tˁ:t\^9 pharyngealization
printline ɹ:\rt	ø:\o/	tˡ:t\^l lateral release
printline ɾ:\fh	ɘ:\er	tⁿ:t\^n, pᵐ p\^m, kᵑ k\^N nasal release
printline ɗ:\d^	ɵ:\o-	tˢ:t\^s, kˣ k\^x, pᶠ p\^f affrication
printline ɬ:\l-	ɤ:\rh	ʸ:\^y (palatalization in a deprecated American notation)
printline ɮ:\lz	ə:\sw	a‿b:a\_ub undertie (liaison, if spaces don't mean breaks in your transcription)
printline ɺ:\rl	ɛ:\ef	ʦ:\ts t–s ligature
printline ʃ:\sh	œ:\oe	ʧ:\tS tesh ligature
printline ʒ:\zh	ɜ:\er	pʼ:p\ap apostrophe (for ejectives)
printline ʈ:\t.	ɞ:\kb
printline ɖ:\d.	ʌ:\vt
printline ɳ:\n.	ɔ:\ct
printline ʂ:\s.	æ:\ae
printline ʐ:\z.	ɐ:\at
printline ɻ:\r.	ɶ:\Oe
printline ɽ:\f.	ɑ:\as
printline ɭ:\l.	ɒ:\ab
printline ɕ:\cc	ɚ:\sr
printline ȵ
printline ʑ:\zc
printline ɟ:\j-
printline ɲ:\nj
printline ç:\c,
printline ʝ:\jc
printline ʎ:\yt
printline ʄ:\j^
printline ɥ:\ht
printline ʍ:\wt
printline ɡ:\gs
printline ŋ:\ng
printline ɣ:\gf
printline ɰ:\ml
printline ɢ:\gc
printline ɴ:\nc
printline χ:\cf
printline ʁ:\ri
printline ʀ:\rc
printline ħ:\h-
printline ʕ:\9e
printline ʡ:\?-
printline ʜ:\hc
printline ʢ:\9-
printline ʔ:\?g
printline ɦ:\h^
printline ɫ:\l~
printline ɧ:\hj
printline t̚:t\cn 	(combining left angle above, corner): unreleased plosive
printline ɜ˞ :\er\hr 	(combining rhotic hook): rhotacized vowel
printline n̩:n\|v 		(combining vertical line below): syllabic consonant
printline b̥:b\0v 		(combining ring below): voiceless (e.g. lenis voiceless plosive, voiceless nasal or approximant)
printline o̞:o\Tv 		(combining down tack below, lowering): lowered vowel; or turns a fricative into an approximant
printline o̝:o\T^ 		(combining up tack below, raising): raised vowel; or turns an approximant into a fricative
printline o̘:o\T( 		(combining left tack below, atr): advanced tongue root
printline o̙:o\T) 		(combining right tack below, rtr): retracted tongue root
printline e̠:e\-v 		(combining macron below): backed
printline o̟:o\+v 		(combining plus sign below): fronted
printline o̤:o\:v 		(combining diaeresis below): breathy voice
printline o̰:o\~v 		(combining tilde below): creaky voice
printline d̪:d\Nv 		(combining bridge below): dental (as opposed to alveolar)
printline d̺:d\Uv 		(combining inverted bridge below): apical
printline d̻:d\Dv 		(combining square below): laminal
printline u̯:u\nv 		(combining inverted breve below): nonsyllabic
printline e̹:e\3v 		(combining right half ring below): slightly rounded
printline u̜:u\cv 		(combining left half ring below): slightly unrounded
printline ɣ̊:\gf\0^ 	(combining ring above): voiceless
printline έ:\ep\'^ 	(combining acute accent): high tone
printline ὲ:\ep\`^ 	(combining grave accent): low tone
printline ε̄:\ep\-^ 	(combining macron): mid tone (or so)
printline ε̃:\ep\~^ 	(combining tilde): nasalized
printline ε̌:\ep\v^ 	(combining caron, haček, wedge): rising tone
printline ε̂:\ep\^^ 	(combining circumflex accent): falling tone
printline ö:o\:^ 		(combining diaeresis): centralized
printline ε̆:ε\N^ 	(combining breve): short
printline t͡s:t\lis 	(combining double inverted breve, ligature): simultaneous articulation, or single segment
printline ː:\:f 		the phonetic length sign
printline ˈ:\'1 		primary stress
printline ˌ:\'2 		secondary stress
printline |:\|f 		the phonetic stroke
printline =========