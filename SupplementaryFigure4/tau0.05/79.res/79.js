
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (79.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 16:33:23", "79.htm#31_01_17at16_33_23"))
	insDoc(aux1, gLnk("R", "Settings", "79.htm#31_01_17at16_33_23_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "79.htm#31_01_17at16_33_23_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "79.htm#31_01_17at16_33_23_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "79.htm#31_01_17at16_33_23_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "79.htm#31_01_17at16_33_23_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "79.htm#31_01_17at16_33_23_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "79.htm#31_01_17at16_33_23_comp_sum_mismatch"))
