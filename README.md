# Maleva Spins

> Aplicativo Flutter para acompanhar e registrar sessões de audição de álbuns da sua coleção Discogs.

---

## Funcionalidades

- Autenticação via Discogs (OAuth)
- Sincronização automática da coleção de álbuns pública do Discogs
- Registro de sessões de audição: escolha um álbum e inicie uma sessão
- Timer global de audição e histórico detalhado
- Notificações locais mostrando o álbum em reprodução (com capa)
- Histórico de sessões com duração, álbum, artista e capa
- Interface moderna e responsiva

## Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/maleva_spins.git
   cd maleva_spins
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Configure o arquivo `.env` com suas credenciais Discogs:
   ```env
   CALLBACKSCHEME = 'maleva'
   CONSUMERKEY = 'SUA_CONSUMER_KEY'
   CONSUMERSECRET = 'SUA_CONSUMER_SECRET'
   ```
4. Execute o app:
   ```bash
   flutter run
   ```

## Estrutura do Projeto

- `lib/`
  - `main.dart`: ponto de entrada do app
  - `pages/`: telas principais (home, histórico, lista de álbuns)
  - `components/`: widgets reutilizáveis (cards, badges, tabs)
  - `models/`: modelos de dados (sessão, histórico, coleção, usuário)
  - `services/`: serviços de timer, Discogs API, armazenamento seguro
  - `theme/`: temas e estilos customizados

## Tecnologias e Pacotes

- Flutter SDK >= 3.10.8
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications): notificações locais
- [shared_preferences](https://pub.dev/packages/shared_preferences): armazenamento local
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage): armazenamento seguro
- [oauth1](https://pub.dev/packages/oauth1): autenticação Discogs
- [google_fonts](https://pub.dev/packages/google_fonts): fontes customizadas
- [app_links](https://pub.dev/packages/app_links): deep links
- [url_launcher](https://pub.dev/packages/url_launcher): abrir URLs

## Como funciona?

- Ao abrir o app, você autentica com Discogs e sua coleção pública é sincronizada.
- Escolha um álbum e inicie uma sessão de audição.
- O timer registra o tempo e salva no histórico.
- Notificações mostram o álbum em reprodução, com capa e tempo.
- O histórico exibe todas as sessões, com detalhes e duração.

## Contribuição

Pull requests são bem-vindos! Para contribuir:

1. Fork o repositório
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas alterações
4. Abra um PR

## Licença

MIT License
