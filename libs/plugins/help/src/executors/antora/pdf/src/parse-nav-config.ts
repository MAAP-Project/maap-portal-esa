import Processor, { Asciidoctor } from 'asciidoctor';
import * as path from 'path';

const asciidoctor = Processor();

const LINK_RX = /<a href="([^"]+)"(?: class="([^"]+)")?>(.+?)<\/a>/;

export interface NavConfig {
  pages: (string | NavTree)[];
}

export type NavTree = { page: string; pages: (string | NavTree)[] };

export function isNavTree(page: string | NavTree): page is NavTree {
  return typeof page !== 'string';
}

function getChildListItems(listItem) {
  const blocks = listItem.getBlocks();
  const candidate = blocks[0];
  if (candidate) {
    if (blocks.length === 1 && candidate.getContext() === 'ulist') {
      return candidate.getItems();
    } else {
      let context;
      return blocks.reduce((accum, block) => {
        if (
          (context = block.getContext()) === 'ulist' ||
          (context === 'open' &&
            (block = block.getBlocks()[0]) &&
            block.getContext() === 'ulist')
        ) {
          accum.push(...block.getItems());
        }
        return accum;
      }, []);
    }
  } else {
    return [];
  }
}

function partitionContent(content: string) {
  if (~content.indexOf('<a')) {
    const match = content.match(LINK_RX);
    if (match) {
      const [, url, role, content] = match;
      let roles;
      if (
        role &&
        role.includes(' ') &&
        (roles = role.split(' ')).includes('xref')
      ) {
        const hashIdx = url.indexOf('#');
        if (~hashIdx) {
          if (roles.includes('unresolved')) {
            return { content, url, urlType: 'internal', unresolved: true };
          } else {
            return {
              content,
              url,
              urlType: 'internal',
              hash: url.substring(hashIdx),
            };
          }
        } else {
          return { content, url, urlType: 'internal' };
        }
      } else if (url.charAt(0) === '#') {
        return { content, url, urlType: 'fragment', hash: url };
      } else {
        return { content, url, urlType: 'external' };
      }
    }
  }
  return { content };
}

function buildNavigationTree(
  formattedContent: string,
  items: Asciidoctor.ListItem[],
  navPath: string
) {
  const entry = formattedContent ? partitionContent(formattedContent) : null;
  let pagePath = null;
  if (entry?.url) {
    const extensionIdx = entry.url.indexOf('.html');
    pagePath = entry.url.substring(0, extensionIdx);
    pagePath = path.join(navPath, 'pages', pagePath);
  }
  if (items.length) {
    const navigationTree = items.map((item) =>
      buildNavigationTree(item.getText(), getChildListItems(item), navPath)
    );

    const navTree: NavTree = {
      page: pagePath,
      pages: navigationTree,
    };
    return navTree;
  } else {
    return pagePath;
  }
}

export function parseNavConfig(navConfigPath: string, navPath: string) {
  const asciiDocNavFile = asciidoctor.loadFile(navConfigPath);

  const navLists: Asciidoctor.List[] = asciiDocNavFile
    .getBlocks()
    .filter((b) => b.getContext() === 'ulist');

  const pages = navLists
    .map((list) => {
      const tree = buildNavigationTree(
        list.getTitle(),
        list.getItems(),
        navPath
      );
      return tree;
    })
    .filter((page) => page);

  const navConfig: NavConfig = {
    pages,
  };

  return navConfig;
}
