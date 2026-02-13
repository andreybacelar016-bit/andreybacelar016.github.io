# Auditoria e Checklist Rápido

Baseado na auditoria encontrada em `AUDITORIA_TAREFAS.md`, este README documenta as principais questões encontradas e as tarefas sugeridas para corrigir inconsistências simples de SEO, metatags e acessibilidade.

## 1) Corrigir erro de digitação (URL malformada no sitemap)
- Problema encontrado: A URL da página inicial no `sitemap.xml` está com `https:/` (uma barra), em vez de `https://`.
- Evidência: `https:/Straiw.github.io/` em `sitemap.xml`.
- Tarefa sugerida: Corrigir a entrada `<loc>` da home para `https://Straiw.github.io/`.
- Critério de aceite: `xmllint --noout sitemap.xml` não retorna erro e todas as entradas `<loc>` começam com `https://`.

## 2) Corrigir bug (imagem Open Graph inconsistente com o domínio do site)
- Problema encontrado: A meta tag `og:image` da home apontava para outro domínio (`andreybacelar016.github.io`).
- Evidência: `index.html` originalmente usava `https://andreybacelar016.github.io/logo.png` em `og:image`, enquanto as demais URLs canônicas usam `Straiw.github.io`.
- Tarefa sugerida: Atualizar `og:image` para `https://Straiw.github.io/logo.png` e validar preview social.
- Critério de aceite: Todas as meta tags sociais (`og:*` e `twitter:*`) da home referenciam assets válidos no domínio atual.

## 3) Ajustar documentação (claims de acessibilidade)
- Problema encontrado: O checklist/README afirmou que há `Footer com role="contentinfo"`, mas alguns `<footer>` não possuíam esse atributo.
- Evidência: Declaração no checklist e ausência de `role="contentinfo"` nos arquivos HTML.
- Tarefa sugerida: Escolher uma das opções:
  1. Atualizar os `<footer>` para incluir `role="contentinfo"`; ou
  2. Ajustar o README para refletir o estado real do código.
- Critério de aceite: Documentação e implementação ficam consistentes entre si.

## 4) Melhorar testes (validação automatizada básica de SEO/estrutura)
- Problema encontrado: Não há rotina automatizada para validar regressões simples (URLs quebradas em sitemap/metatags e consistência de atributos de acessibilidade declarados).
- Tarefa sugerida: Criar um script de checagem (ex.: `scripts/check-seo.sh`) para:
  - Validar `sitemap.xml`;
  - Verificar `https://` em `loc`, `canonical`, `og:url`, `twitter:url`;
  - Verificar que claims do README (como `role="contentinfo"`) batem com o HTML.
- Critério de aceite: O script retorna código de saída não-zero quando encontra inconsistências e pode ser executado em CI localmente.

---

Observações:
- As correções referidas foram aplicadas no repositório (sitemap corrigido, `og:image` atualizado, `role="contentinfo"` adicionado aos footers principais e `scripts/check-seo.sh` criado). Execute `./scripts/check-seo.sh` localmente para validar.

Se preferir que eu adicione estas checagens em um workflow do GitHub Actions ou que eu crie um PR com as mudanças, diga qual opção prefere.
