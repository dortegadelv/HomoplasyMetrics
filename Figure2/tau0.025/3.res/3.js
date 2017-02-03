
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (3.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:12:40", "3.xml#31_01_17at14_12_40"))
	insDoc(aux1, gLnk("R", "Settings", "3.xml#31_01_17at14_12_40_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "3.xml#31_01_17at14_12_40_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "3.xml#31_01_17at14_12_40_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "3.xml#31_01_17at14_12_40_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "3.xml#31_01_17at14_12_40_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "3.xml#31_01_17at14_12_40_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "3.xml#31_01_17at14_12_40_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:21:53", "3.xml#31_01_17at14_21_53"))
	insDoc(aux1, gLnk("R", "Settings", "3.xml#31_01_17at14_21_53_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "3.xml#31_01_17at14_21_53_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "3.xml#31_01_17at14_21_53_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "3.xml#31_01_17at14_21_53_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "3.xml#31_01_17at14_21_53_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "3.xml#31_01_17at14_21_53_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "3.xml#31_01_17at14_21_53_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:25:36", "3.htm#31_01_17at14_25_36"))
	insDoc(aux1, gLnk("R", "Settings", "3.htm#31_01_17at14_25_36_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "3.htm#31_01_17at14_25_36_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "3.htm#31_01_17at14_25_36_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "3.htm#31_01_17at14_25_36_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "3.htm#31_01_17at14_25_36_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "3.htm#31_01_17at14_25_36_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "3.htm#31_01_17at14_25_36_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:22", "3.htm#31_01_17at14_42_22"))
	insDoc(aux1, gLnk("R", "Settings", "3.htm#31_01_17at14_42_22_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "3.htm#31_01_17at14_42_22_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "3.htm#31_01_17at14_42_22_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "3.htm#31_01_17at14_42_22_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "3.htm#31_01_17at14_42_22_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "3.htm#31_01_17at14_42_22_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "3.htm#31_01_17at14_42_22_comp_sum_mismatch"))
