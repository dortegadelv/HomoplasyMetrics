
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (19.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 15:05:38", "19.htm#31_01_17at15_05_38"))
	insDoc(aux1, gLnk("R", "Settings", "19.htm#31_01_17at15_05_38_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "19.htm#31_01_17at15_05_38_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "19.htm#31_01_17at15_05_38_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "19.htm#31_01_17at15_05_38_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "19.htm#31_01_17at15_05_38_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "19.htm#31_01_17at15_05_38_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "19.htm#31_01_17at15_05_38_comp_sum_mismatch"))
