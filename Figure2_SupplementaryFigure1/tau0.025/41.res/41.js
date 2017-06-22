
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (41.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:13:37", "41.xml#31_01_17at14_13_37"))
	insDoc(aux1, gLnk("R", "Settings", "41.xml#31_01_17at14_13_37_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "41.xml#31_01_17at14_13_37_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "41.xml#31_01_17at14_13_37_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "41.xml#31_01_17at14_13_37_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "41.xml#31_01_17at14_13_37_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "41.xml#31_01_17at14_13_37_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "41.xml#31_01_17at14_13_37_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:34:38", "41.htm#31_01_17at14_34_38"))
	insDoc(aux1, gLnk("R", "Settings", "41.htm#31_01_17at14_34_38_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "41.htm#31_01_17at14_34_38_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "41.htm#31_01_17at14_34_38_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "41.htm#31_01_17at14_34_38_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "41.htm#31_01_17at14_34_38_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "41.htm#31_01_17at14_34_38_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "41.htm#31_01_17at14_34_38_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:29", "41.htm#31_01_17at14_42_29"))
	insDoc(aux1, gLnk("R", "Settings", "41.htm#31_01_17at14_42_29_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "41.htm#31_01_17at14_42_29_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "41.htm#31_01_17at14_42_29_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "41.htm#31_01_17at14_42_29_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "41.htm#31_01_17at14_42_29_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "41.htm#31_01_17at14_42_29_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "41.htm#31_01_17at14_42_29_comp_sum_mismatch"))
