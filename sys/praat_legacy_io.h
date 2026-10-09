#ifndef _praat_legacy_io_h_
#define _praat_legacy_io_h_
#include "Table.h"
void praat_formatLegacyText (MelderFile file);
autoTable praat_readLegacyTable (MelderFile file, conststring32 headerHint);
#endif
