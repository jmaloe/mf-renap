export type IMfHubRuntime = Readonly<{
  remotes: Record<string, IMfHubRuntimeParent>;
}>;

export type IMfHubRuntimeParent = Readonly<{
  id: string;
  transactionCode?: string;
  iconUrl?: string;
  url?: string;
  modulePath?: string;
  children?: IMfHubRuntimeChild[];
}>;

export interface IMfHubRuntimeChild {
  id: string;
  transactionCode?: string;
  iconUrl?: string;
  url?: string;
  modulePath?: string;
}
