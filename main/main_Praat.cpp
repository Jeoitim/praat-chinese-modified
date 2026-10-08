/* main_Praat.cpp
 *
 * Copyright (C) 1992-2008,2010-2021,2023-2026 Paul Boersma
 *
 * This code is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or (at
 * your option) any later version.
 *
 * This code is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this work. If not, see <http://www.gnu.org/licenses/>.
 */

#include "../sys/praat.h"
#include "main_Praat.h"
#include "../sys/praat_chinese.h"

void praat_chinese_loadFonts ();

static void logo (Graphics g) {
    Graphics_setWindow(g,0,1,0,1);
    Graphics_setColour(g,MelderColour(0.965,0.972,0.985));Graphics_fillRectangle(g,0,1,0,1);
    Graphics_setFont(g,kGraphics_font::HELVETICA);Graphics_setUnderscoreIsSubscript(g,false);
    Graphics_setTextAlignment(g,Graphics_LEFT,Graphics_HALF);
    Graphics_setColour(g,MelderColour(0.02,0.25,0.47));Graphics_setFontSize(g,25);
    Graphics_text(g,0.24,0.90,U"Praat 修改版");
    try { Graphics_imageFromFile(g,Melder_cat(praat_chineseDirectory(),U"/assets/icon.png"),0.067,0.198,0.74,0.96); } catch(MelderError) { Melder_clearError(); }
    Graphics_setFontSize(g,12);Graphics_setColour(g,MelderColour(0.34,0.40,0.49));
    Graphics_text(g,0.24,0.80,U"电脑上的语音实验台");
    Graphics_setFontSize(g,10);
    Graphics_text(g,0.24,0.74,U"7.0.02");
    Graphics_setColour(g,Melder_WHITE);Graphics_fillRoundedRectangle(g,0.055,0.945,0.10,0.70,3);
    Graphics_setFontSize(g,11);Graphics_setColour(g,MelderColour(0.15,0.20,0.28));
    Graphics_text(g,0.085,0.62,U"修改版维护：jeoitim");
    Graphics_text(g,0.085,0.48,U"汉化及自定义内容：贝先明、向柠");
    Graphics_text(g,0.085,0.34,U"现代界面与汉化手册：KasumiKitsune");
    Graphics_setFontSize(g,10);
    Graphics_text(g,0.085,0.20,U"Praat 核心：Paul Boersma、David Weenink、Anastasia Shchupak");
}

int main (int argc, char *argv []) {
	try {
		praat_chinese_loadFonts ();
		//TRACE
		praat_setLogo (155.0, 105.0, logo);
		MelderStopwatch stopwatch;
		praat_init (U"" stringize (PRAAT_NAME),
			U"" stringize (PRAAT_VERSION_STR), PRAAT_VERSION_NUM,
			PRAAT_YEAR, PRAAT_MONTH, PRAAT_DAY,
			U"paul.boersma", U"uva.nl",
			argc, argv
		);
		trace (stopwatch());
		INCLUDE_LIBRARY (praat_uvafon_init)
		trace (stopwatch());
		praat_chinese_init ();
		praat_run ();
		trace (stopwatch());
	} catch (MelderError) {
		Melder_flushError (
			U"This error message percolated all the way to the top.\n"
			U"Praat will now quit; contact the authors if this is unexpected."
		);   // an attempt to catch Apache errors
	}
	return 0;   // obligatory (because on Windows `main` is just a normal function called from our WinMain)
}

/* End of file main_Praat.cpp */
