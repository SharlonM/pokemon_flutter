
# **Pokemon**
## **Listando Pokemons**
### Veja os detalhes dos pokemons e salve seus pokemons favoritos localmente

#### Funcionalidades esperadas
- [x] Listar pokemons incluindo suas habilidades e caracteristicas
- [ ] Implementar conceito infite loading ( decisão pessoal de não colocar para automatico, quem desejar pode remover o botão e colocar a função direto )
- [x] Selecionar pokemon e ver seus detalhes
- [x] Buscar pokemons por nome ( opcional )
- [x] Salvar informações dos pokemons em banco local ( opcional )

#### Dependencias usadas
```
cupertino_icons: ^1.0.2
floor: ^1.1.0
http: ^0.13.3
window_size:
  git:
    url: git://github.com/google/flutter-desktop-embedding.git
    path: plugins/window_size
```
### Observações
Programa criado usando o android studio 4.2.2 utilizando o FLUTTER usando a biblioteca nativa do Http para consumir a Api do https://pokeapi.co/ e a dependecia do floor para ajudar na integração com o SQLite.

 Os layouts foram construidos usando Material Design da google
 #### Aplicação simples usando o BottomNavigator para mudanças de telas sendo elas:
 - **Todos:** Lista todos os pokemons, primeiramente consultando o banco local, caso não encontre dados utiliza a API para alimentar, de 10 em 10 apenas solicitando novos quando solicitado.
 - **Pesquise:** Tela simples para pesquisar o pokemon desejado, primeiramente faz a pesquisa local usando LIKE e listando todos, se não encontrar faz a pesquisa API retornando apenas 1 resultado.
 - **Favoritos:** Tela onde os pokemons escolhidos para serem favoritos são listados (pokemons adcionados como favoritos são salvos localmente para uma visualização mais 
 rapida e sem precisar de conexão )
 
 ### Build
 Para realizar o download do APK acesse o link abaixo ( lembrando que o target api é acima da 23, Android 6.0 )
 
 [V1](https://drive.google.com/file/d/1uG25poYhI8D3f6VnETTNKajvsReSW43I/view?usp=sharing)
 
 [DEBUG](https://drive.google.com/file/d/1IOQULdeYHxeEjMqhq6l9-P1s8utYBXm4/view?usp=sharing)
 
 [DESKTOP](https://drive.google.com/file/d/1r_a-3AtrIGhmuAw-ZLpik9R32Oy3BCY2/view?usp=sharing) ( VERSÃO TESTE PARA COMPUTADOR )
 
 
 - Video demonstrando o funcionamento do app
 
 [VIDEO](https://drive.google.com/file/d/17_RdfZFOpuonTPyTBzF2ErLgAiskHJcT/view?usp=sharing)
