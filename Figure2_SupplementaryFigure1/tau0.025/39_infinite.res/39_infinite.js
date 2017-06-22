
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (39_infinite.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:13:35", "39_infinite.xml#31_01_17at14_13_35"))
	insDoc(aux1, gLnk("R", "Settings", "39_infinite.xml#31_01_17at14_13_35_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "39_infinite.xml#31_01_17at14_13_35_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "39_infinite.xml#31_01_17at14_13_35_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "39_infinite.xml#31_01_17at14_13_35_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "39_infinite.xml#31_01_17at14_13_35_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "39_infinite.xml#31_01_17at14_13_35_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "39_infinite.xml#31_01_17at14_13_35_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:34:17", "39_infinite.htm#31_01_17at14_34_17"))
	insDoc(aux1, gLnk("R", "Settings", "39_infinite.htm#31_01_17at14_34_17_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "39_infinite.htm#31_01_17at14_34_17_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "39_infinite.htm#31_01_17at14_34_17_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "39_infinite.htm#31_01_17at14_34_17_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "39_infinite.htm#31_01_17at14_34_17_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "39_infinite.htm#31_01_17at14_34_17_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "39_infinite.htm#31_01_17at14_34_17_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:29", "39_infinite.htm#31_01_17at14_42_29"))
	insDoc(aux1, gLnk("R", "Settings", "39_infinite.htm#31_01_17at14_42_29_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "39_infinite.htm#31_01_17at14_42_29_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "39_infinite.htm#31_01_17at14_42_29_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "39_infinite.htm#31_01_17at14_42_29_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "39_infinite.htm#31_01_17at14_42_29_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "39_infinite.htm#31_01_17at14_42_29_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "39_infinite.htm#31_01_17at14_42_29_comp_sum_mismatch"))
