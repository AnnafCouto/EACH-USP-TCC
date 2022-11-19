###	Script de processamento de dados de GC-MS utilizando o pacote metaMS ###
###
###	Autora: Anna Clara de Freitas Couto, 2022.
###
### Requisitos: 
### 	R
###		metaMS
###		NormalyzerDE
###
### Instruções iniciais:
### 	Os arquivos a serem processados devem estar em uma pasta 'Dados_teste' dentro do diretório 'Documentos' do computador.
### 	Após a finalização do processamento, o usuário deve fazer o uploado do arquivo 'spectra.msp' no software NIST MS Search e fazer a anotação na planilha 'Quantificacao_normalizada.csv'.
###
###

library(metaMS)
data(FEMsettings)
library(NormalyzerDE)


result <- runGC(files = "~/Documentos/Dados_teste", settings = TSQXLS.GC)
write.msp (result$PseudoSpectra, file = 'spectra.msp')
write.csv (result$PeakTable, file = 'peakTable.csv', row.names = FALSE)
# realizar a normalização manual no arquivo 'peakTable.csv', como normalização por peso ou concentração, e salvar para continuar
peaktable <- result$PeakTable
mat <- peaktable [,c(6:ncol(peaktable))]
mat[mat == 0] <- NA
mat[mat > 0 & mat < 1] <- 0
mat <- performCyclicLoessNormalization(mat)
peaktable <- cbind(peaktable [, c(1:4)], mat)
write.csv(peaktable, 'Quantificacao_normalizada.csv', row.names = FALSE)


###
###
###