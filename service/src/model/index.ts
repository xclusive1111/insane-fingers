export interface QuoteForm {
  words: string;
  addedBy: string;
}

export interface Quote {
  id: number;
  words: string;
  added_by: string;
}

export interface ApiError {
  status: number;
  message: string;
}