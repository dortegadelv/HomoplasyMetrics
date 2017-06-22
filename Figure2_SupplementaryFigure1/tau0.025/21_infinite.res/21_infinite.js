
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (21_infinite.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:13:08", "21_infinite.xml#31_01_17at14_13_08"))
	insDoc(aux1, gLnk("R", "Settings", "21_infinite.xml#31_01_17at14_13_08_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "21_infinite.xml#31_01_17at14_13_08_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "21_infinite.xml#31_01_17at14_13_08_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "21_infinite.xml#31_01_17at14_13_08_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "21_infinite.xml#31_01_17at14_13_08_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "21_infinite.xml#31_01_17at14_13_08_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "21_infinite.xml#31_01_17at14_13_08_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:30:06", "21_infinite.htm#31_01_17at14_30_06"))
	insDoc(aux1, gLnk("R", "Settings", "21_infinite.htm#31_01_17at14_30_06_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "21_infinite.htm#31_01_17at14_30_06_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "21_infinite.htm#31_01_17at14_30_06_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "21_infinite.htm#31_01_17at14_30_06_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "21_infinite.htm#31_01_17at14_30_06_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "21_infinite.htm#31_01_17at14_30_06_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "21_infinite.htm#31_01_17at14_30_06_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:25", "21_infinite.htm#31_01_17at14_42_25"))
	insDoc(aux1, gLnk("R", "Settings", "21_infinite.htm#31_01_17at14_42_25_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "21_infinite.htm#31_01_17at14_42_25_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "21_infinite.htm#31_01_17at14_42_25_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "21_infinite.htm#31_01_17at14_42_25_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "21_infinite.htm#31_01_17at14_42_25_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "21_infinite.htm#31_01_17at14_42_25_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "21_infinite.htm#31_01_17at14_42_25_comp_sum_mismatch"))