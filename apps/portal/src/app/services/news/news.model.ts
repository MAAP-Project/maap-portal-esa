export interface News {
  id: number;
  path: string;
  title: string;
  author: string;
  date: Date;
  articleBackgroundUrl?: string;
  description?: string;
}
