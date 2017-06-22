
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (34.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:13:27", "34.xml#31_01_17at14_13_27"))
	insDoc(aux1, gLnk("R", "Settings", "34.xml#31_01_17at14_13_27_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "34.xml#31_01_17at14_13_27_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "34.xml#31_01_17at14_13_27_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "34.xml#31_01_17at14_13_27_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "34.xml#31_01_17at14_13_27_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "34.xml#31_01_17at14_13_27_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "34.xml#31_01_17at14_13_27_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:33:02", "34.htm#31_01_17at14_33_02"))
	insDoc(aux1, gLnk("R", "Settings", "34.htm#31_01_17at14_33_02_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "34.htm#31_01_17at14_33_02_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "34.htm#31_01_17at14_33_02_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "34.htm#31_01_17at14_33_02_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "34.htm#31_01_17at14_33_02_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "34.htm#31_01_17at14_33_02_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "34.htm#31_01_17at14_33_02_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:28", "34.htm#31_01_17at14_42_28"))
	insDoc(aux1, gLnk("R", "Settings", "34.htm#31_01_17at14_42_28_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "34.htm#31_01_17at14_42_28_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "34.htm#31_01_17at14_42_28_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "34.htm#31_01_17at14_42_28_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "34.htm#31_01_17at14_42_28_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "34.htm#31_01_17at14_42_28_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "34.htm#31_01_17at14_42_28_comp_sum_mismatch"))