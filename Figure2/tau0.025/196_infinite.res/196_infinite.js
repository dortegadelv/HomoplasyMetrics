
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:///C:/Program%20Files/WinArl3.5/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (196_infinite.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:17:18", "196_infinite.xml#31_01_17at14_17_18"))
	insDoc(aux1, gLnk("R", "Settings", "196_infinite.xml#31_01_17at14_17_18_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "196_infinite.xml#31_01_17at14_17_18_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "196_infinite.xml#31_01_17at14_17_18_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "196_infinite.xml#31_01_17at14_17_18_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "196_infinite.xml#31_01_17at14_17_18_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "196_infinite.xml#31_01_17at14_17_18_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "196_infinite.xml#31_01_17at14_17_18_comp_sum_mismatch"))
	aux1 = insFld(foldersTree, gFld("Run of 31/01/17 at 14:42:58", "196_infinite.htm#31_01_17at14_42_58"))
	insDoc(aux1, gLnk("R", "Settings", "196_infinite.htm#31_01_17at14_42_58_run_information"))
		aux2 = insFld(aux1, gFld("Samples", ""))
		insDoc(aux2, gLnk("R", "Tus muestras", "196_infinite.htm#31_01_17at14_42_58_group0"))
		aux2 = insFld(aux1, gFld("Within-samples summary", ""))
		insDoc(aux2, gLnk("R", "Basic indices", "196_infinite.htm#31_01_17at14_42_58_comp_sum_Basic"))
		insDoc(aux2, gLnk("R", "Heterozygosity", "196_infinite.htm#31_01_17at14_42_58_comp_sum_het"))
		insDoc(aux2, gLnk("R", "No. of alleles", "196_infinite.htm#31_01_17at14_42_58_comp_sum_numAll"))
		insDoc(aux2, gLnk("R", "Molecular diversity", "196_infinite.htm#31_01_17at14_42_58_comp_sum_moldiv"))
		insDoc(aux2, gLnk("R", "Mismatch analysis", "196_infinite.htm#31_01_17at14_42_58_comp_sum_mismatch"))
