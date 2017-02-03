
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (1.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 16:34:04", "1.htm#31_01_17at16_34_04"))
	insDoc(aux1, gLnk("R", "Settings", "1.htm#31_01_17at16_34_04_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "1.htm#31_01_17at16_34_04_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "1.htm#31_01_17at16_34_04_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "1.htm#31_01_17at16_34_04_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "1.htm#31_01_17at16_34_04_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "1.htm#31_01_17at16_34_04_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "1.htm#31_01_17at16_34_04_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 16:35:29", "1.htm#31_01_17at16_35_29"))
	insDoc(aux1, gLnk("R", "Settings", "1.htm#31_01_17at16_35_29_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "1.htm#31_01_17at16_35_29_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "1.htm#31_01_17at16_35_29_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "1.htm#31_01_17at16_35_29_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "1.htm#31_01_17at16_35_29_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "1.htm#31_01_17at16_35_29_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "1.htm#31_01_17at16_35_29_comp_sum_mismatch"))
