
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (188.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:17:06", "188.xml#31_01_17at14_17_06"))
	insDoc(aux1, gLnk("R", "Settings", "188.xml#31_01_17at14_17_06_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "188.xml#31_01_17at14_17_06_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "188.xml#31_01_17at14_17_06_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "188.xml#31_01_17at14_17_06_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "188.xml#31_01_17at14_17_06_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "188.xml#31_01_17at14_17_06_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "188.xml#31_01_17at14_17_06_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:57", "188.htm#31_01_17at14_42_57"))
	insDoc(aux1, gLnk("R", "Settings", "188.htm#31_01_17at14_42_57_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "188.htm#31_01_17at14_42_57_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "188.htm#31_01_17at14_42_57_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "188.htm#31_01_17at14_42_57_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "188.htm#31_01_17at14_42_57_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "188.htm#31_01_17at14_42_57_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "188.htm#31_01_17at14_42_57_comp_sum_mismatch"))
