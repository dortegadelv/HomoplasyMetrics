
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (16.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:13:00", "16.xml#31_01_17at14_13_00"))
	insDoc(aux1, gLnk("R", "Settings", "16.xml#31_01_17at14_13_00_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "16.xml#31_01_17at14_13_00_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "16.xml#31_01_17at14_13_00_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "16.xml#31_01_17at14_13_00_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "16.xml#31_01_17at14_13_00_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "16.xml#31_01_17at14_13_00_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "16.xml#31_01_17at14_13_00_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:28:45", "16.htm#31_01_17at14_28_45"))
	insDoc(aux1, gLnk("R", "Settings", "16.htm#31_01_17at14_28_45_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "16.htm#31_01_17at14_28_45_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "16.htm#31_01_17at14_28_45_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "16.htm#31_01_17at14_28_45_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "16.htm#31_01_17at14_28_45_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "16.htm#31_01_17at14_28_45_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "16.htm#31_01_17at14_28_45_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:24", "16.htm#31_01_17at14_42_24"))
	insDoc(aux1, gLnk("R", "Settings", "16.htm#31_01_17at14_42_24_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "16.htm#31_01_17at14_42_24_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "16.htm#31_01_17at14_42_24_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "16.htm#31_01_17at14_42_24_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "16.htm#31_01_17at14_42_24_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "16.htm#31_01_17at14_42_24_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "16.htm#31_01_17at14_42_24_comp_sum_mismatch"))
