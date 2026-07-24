import { BaseHttpClient } from "@/utils/http/baseHttpClient";

class HttpClient extends BaseHttpClient {
  async get<T>(
    endpoint: string,
    token: string,
    options?: RequestInit,
  ): Promise<T> {
    const response = await this.execute(endpoint, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        ...(token && {
          Authorization: `Bearer ${token}`,
        }),
        ...options?.headers,
      },
      ...options,
    });

    return response.json();
  }

  async post<T>(
    endpoint: string,
    token: string,
    data?: unknown,
    options?: RequestInit,
  ): Promise<T> {
    const response = await this.execute(endpoint, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        ...(token && {
          Authorization: `Bearer ${token}`,
        }),
        ...options?.headers,
      },
      body: data ? JSON.stringify(data) : undefined,
      ...options,
    });

    return response.json();
  }
}

export const http = new HttpClient();
