# Auditoria da base — tarefas sugeridas

> Documento revisado para remover ambiguidades e alinhar os achados com o estado atual do repositório.

## 1) Corrigir erro de digitação no `sitemap.xml` (alta prioridade)
- **Achado:** A URL da home está malformada (`https:/` com uma barra).
- **Onde:** `<loc>https:/Straiw.github.io/</loc>`.
- **Impacto:** Pode prejudicar indexação da URL raiz por buscadores.
- **Tarefa:** Ajustar para `https://Straiw.github.io/`.
- **Critério de aceite:**
  - Todas as entradas `<loc>` do `sitemap.xml` começam com `https://`.
  - `xmllint --noout sitemap.xml` finaliza sem erro.

## 2) Corrigir inconsistência de metadado social (`og:image`) (média prioridade)
- **Achado:** A home usa `og:image` com domínio diferente (`andreybacelar016.github.io`).
- **Onde:** `index.html` em `<meta property="og:image" ...>`.
- **Impacto:** Preview social pode apontar para asset externo não controlado pelo projeto.
- **Tarefa:** Padronizar para `https://Straiw.github.io/logo.png`.
- **Critério de aceite:**
  - `og:image` e `twitter:image` apontam para domínio oficial do projeto.
  - Preview social da home carrega imagem corretamente.

## 3) Corrigir discrepância entre README e implementação de acessibilidade (média prioridade)
- **Achado:** README afirma `Footer com role="contentinfo"`, mas os HTMLs usam `<footer>` sem esse atributo.
- **Onde:** item de checklist no `README.md` e páginas HTML (`index.html`, `moda.html`, `maquiagem.html`, `privacidade.html`, `termos.html`).
- **Impacto:** Documentação inconsistente gera dúvida para manutenção e revisão.
- **Tarefa (escolher 1):**
  1. Atualizar todos os `<footer>` para incluir `role="contentinfo"`; **ou**
  2. Ajustar o item do README para refletir o comportamento real.
- **Critério de aceite:** README e HTML descrevem/implementam o mesmo padrão.

## 4) Melhorar testes com validação automatizada de SEO/consistência (média prioridade)
- **Achado:** Não existe checagem automatizada para evitar regressões simples de SEO e documentação.
- **Tarefa:** Criar script (ex.: `scripts/check-seo.sh`) com validações mínimas:
  - Integridade XML do `sitemap.xml`.
  - URLs com `https://` em `sitemap.xml`, `canonical`, `og:url`, `twitter:url`.
  - Consistência entre claims do README e marcação HTML (ex.: `contentinfo`).
- **Critério de aceite:**
  - Script retorna `0` quando tudo está correto.
  - Script retorna código diferente de `0` quando encontrar inconsistências.

---

## Ordem recomendada de execução
1. Tarefa 1 (corrige indexação básica).
2. Tarefa 2 (corrige metadados sociais).
3. Tarefa 3 (alinha documentação com implementação).
4. Tarefa 4 (evita regressão futura).
