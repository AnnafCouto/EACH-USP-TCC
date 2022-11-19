###	Script de processamento de dados de GC-MS utilizando os pacotes xcms/CAMERA com correlação de picos ###
###
###	Autora: Anna Clara de Freitas Couto, 2022.
###
### Requisitos: 
###   R 
###   xcms (pacote)
###   CAMERA (pacote)
###   NormalyzerDE (pacote)
###   arquivo 'metadata.csv', com nome das amostras e grupos descritivos por coluna.
###
### Instruções iniciais:
### 	Os arquivos a serem processados devem estar em uma pasta 'Dados_teste' dentro do diretório 'Documentos' do computador.
### 	Após a finalização do processamento, o usuário deve fazer o uploado do arquivo 'spectra.msp' no software NIST MS Search e fazer a anotação na planilha 'Quantificacao_normalizada.csv'.
###
###

library(MSnbase)
library(xcms)
library(CAMERA)
library(CluMSID)
library(metaMS)
library(NormalyzerDE)
library(BiocParallel)
library(metaMS)

# Pré-processamento, incluindo leitura dos arquivos, detecção de picos, agrupamento e correção do tepo de retenção
xs <- xcmsSet (list.files(path = "~/Documentos/Dados_teste", pattern = '.mzXML'), method = "matchedFilter", fwhm = 5,snthresh = 2, step= 0.1, steps= 2,sigma = 3.56718192627824, max= 500, mzdiff= 1,index= FALSE,phenoData = metadata, sclass = metadata$group, snames = metadata$sample, polarity = 'positive')
xs2 <- group (xs,method = "density", bw=0.5, mzwid= 1, minfrac = 0.3, minsamp = 1,max = 500)
xset2 <- retcor (xs2)
xset3 <- group (xset2,method = "density", bw=0.5, mzwid= 1, minfrac = 0.3, minsamp = 1,max = 500)
xset<- fillPeaks (xset3)

# Proposição dos espectros
an<-xsAnnotate(xset, polarity = 'positive')
anF<-groupFWHM(an, perfwhm=1)
anIC <- groupCorr(anF, calcIso = FALSE)
pslist <- extract_spectra(anIC)
writeFeaturelist(pslist, "pre_anno.csv")
create_spectra(pslist)

# O usuário deve, nesse momento, fazer o upload do arquivo 'spectra.msp' no software NIST MS Search e realizar a anotação dos espectros na planilha 'pre_anno.csv'.

# adaptação dos dados de identificação
pre_anno <- read.csv("pre_anno.csv", sep = ",", na.string = c("NA", ""))
peaktable <- matrix(nrow = nrow(pre_anno), ncol = 3 + length(list.files(path = "~/Documentos/Dados_teste", pattern = '.mzXML')))
colnames(peaktable) [1:3] <- c("Name", "rt", "mz")
peaktable[, "Name"] <- pre_anno[, "annotation"]
peaktable[, "rt"] <- pre_anno [, "rt"]

# obtenção dos valores de intensidade dos espectros
sample_col <- paste0('X', 1:nrow(metadata))
for (i in 1:length(pslist)) {
  ion_mass <- pslist[[i]]@spectrum[which(pslist[[i]]@spectrum [,2] == max(pslist[[i]]@spectrum[,2])),1][1]
  peaktable[i, "mz"] <- ion_mass
  ion_id <- which (anIC@groupInfo[anIC@pspectra[pslist[[i]]@id][[1]], 'mz'] == ion_mass)
  spec <- anIC@groupInfo[anIC@pspectra[pslist[[i]]@id][[1]], sample_col]
  if (length(ion_id)>1) {
    peaktable[i, metadata$sample] <- apply(spec [ion_id,], 2, sum)
  } else {peaktable[i, metadata$sample] <- spec [ion_id,]}
}
write.csv(peaktable, "PeakTable.csv", row.names = FALSE, na = "")
# realizar a normalização manual no arquivo 'peakTable.csv', como normalização por peso ou concentração, e salvar para continuar
mat <- peaktable [,c(4:ncol(peaktable))]
mat[mat == 0] <- NA
mat[mat > 0 & mat < 1] <- 0
mat <- apply(mat, 2, as.numeric)

# normalização por regressão linear cíclica (CycLoess)
mat <- performCyclicLoessNormalization(mat)
peaktable <- cbind(peaktable [, c(1:3)], mat)
write.csv(peaktable, 'Quantificacao_normalizada.csv', row.names = FALSE)

###
###	Comentários:
###		Para diminuir o tempo total de processamento em máquinas com estrutura computacional com mais de um core, é possível optar pro processamentos paralelos através do argumento "BPPARAM" nas funções do xcms.
###		Os arquivos processados tem extensão '.mzXML', mas é possível ler arquivos em extensão '.mzML'. Se for este o caso, o argumento "pattern" deve ser alterado.
###
###
