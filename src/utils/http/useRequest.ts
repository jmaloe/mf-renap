import { useCallback, useState } from "react";

type IProps = {
  loading: boolean;
};

type IRequestResult<T> = {
  data: T | null;
  error: string | null;
};

export const useRequest = <T>() => {
  const [state, setState] = useState<IProps>({
    loading: false,
  });

  const execute = useCallback(
    async (callback: () => Promise<T>): Promise<IRequestResult<T>> => {
      setState({ loading: true });
      try {
        const data = await callback();
        setState((prev) => ({
          ...prev,
          loading: false,
        }));
        return { data, error: null };
      } catch (error) {
        setState({
          loading: false,
        });
        return {
          data: null,
          error: error instanceof Error ? error.message : String(error),
        };
      }
    },
    [],
  );

  return { ...state, execute };
};
