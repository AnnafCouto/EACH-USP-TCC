# Trabalho de Conclusão de Curco

Trabalho de conclusão de curso apresentado à Universidade de São Paulo (EACH-USP) em 2022 para conclusão do curso de Bacharelado em Biotecnologia. 


## Avaliação de diferentes ferramentas de processamento de dados de GC-MS para metabolômica


### Resumo

A cromatografia associada à espectrometria de massas é uma técnica analítica de cunho  interdisciplinar capaz de realizar a identificação e quantificação de moléculas em uma mistura complexa. Uma vez que os dados gerados são multidimensionais e de alta complexidade, são necessárias ferramentas computacionais para o tratamento, processamento e interpretação dos resultados. Para tanto, foram testados pacotes de programação em R para tratamento de dados de GC-MS já processados e publicados, utilizando-se o pacote metaMS e dois scripts propostos a partir dos pacotes xcms e CAMERA, comparativamente ao pacote TargetSearch, utilizado no processamento original dos dados. Os resultados foram avaliados em relação às etapas de identificação e quantificação dos processamentos, com discussão sobre os algoritmos e parâmetros utilizados em cada metodologia. O pacote metaMS obteve melhor performance na etapa de identificação, com escores de similaridade médios considerados bons, e identificou 73% dos metábolitos identificados pelo método original, com adicional de 3 novos metabólitos identificados. Os scripts com e sem informação de correlação de picos identificaram 38,3% e 27,6% metabólitos originais, respectivamente, com valores de similaridade com a base de dados considerados adequados. A quantificação demonstrou que o metaMS tem maior precisão na extração das intensidades de réplicas, em comparação com o método original e os scripts. No entanto, os scripts geraram dados que melhor se agrupam de acordo com suas características descritivas em análise de PCA. Dessa forma, demonstrou-se a importância da análise crítica dos parâmetros e funções utilizadas, além da avaliação dos resultados finais para otimização do fluxo de processamento de dados, com proposição de melhorias e implementações futuras para os métodos alternativos avaliados.

### Descrição

Este repositório contém os scripts utilizados para o processamento dos dados de teste, funções adicionais e resultados de quantificação obtidos.  

Em caso de dúvidas, entre em contato.
