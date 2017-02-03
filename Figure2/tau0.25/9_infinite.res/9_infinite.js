
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (9_infinite.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 15:05:32", "9_infinite.htm#31_01_17at15_05_32"))
	insDoc(aux1, gLnk("R", "Settings", "9_infinite.htm#31_01_17at15_05_32_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "9_infinite.htm#31_01_17at15_05_32_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "9_infinite.htm#31_01_17at15_05_32_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "9_infinite.htm#31_01_17at15_05_32_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "9_infinite.htm#31_01_17at15_05_32_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "9_infinite.htm#31_01_17at15_05_32_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "9_infinite.htm#31_01_17at15_05_32_comp_sum_mismatch"))
