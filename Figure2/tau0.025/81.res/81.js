
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (81.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:14:35", "81.xml#31_01_17at14_14_35"))
	insDoc(aux1, gLnk("R", "Settings", "81.xml#31_01_17at14_14_35_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "81.xml#31_01_17at14_14_35_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "81.xml#31_01_17at14_14_35_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "81.xml#31_01_17at14_14_35_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "81.xml#31_01_17at14_14_35_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "81.xml#31_01_17at14_14_35_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "81.xml#31_01_17at14_14_35_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:37", "81.htm#31_01_17at14_42_37"))
	insDoc(aux1, gLnk("R", "Settings", "81.htm#31_01_17at14_42_37_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "81.htm#31_01_17at14_42_37_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "81.htm#31_01_17at14_42_37_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "81.htm#31_01_17at14_42_37_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "81.htm#31_01_17at14_42_37_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "81.htm#31_01_17at14_42_37_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "81.htm#31_01_17at14_42_37_comp_sum_mismatch"))
