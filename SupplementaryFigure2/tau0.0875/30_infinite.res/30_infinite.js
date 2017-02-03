
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (30_infinite.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 16:40:34", "30_infinite.htm#31_01_17at16_40_34"))
	insDoc(aux1, gLnk("R", "Settings", "30_infinite.htm#31_01_17at16_40_34_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "30_infinite.htm#31_01_17at16_40_34_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "30_infinite.htm#31_01_17at16_40_34_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "30_infinite.htm#31_01_17at16_40_34_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "30_infinite.htm#31_01_17at16_40_34_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "30_infinite.htm#31_01_17at16_40_34_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "30_infinite.htm#31_01_17at16_40_34_comp_sum_mismatch"))
