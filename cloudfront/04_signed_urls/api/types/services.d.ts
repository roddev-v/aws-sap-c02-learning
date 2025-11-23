export namespace Services {
  interface ISecretsService {
    get<T>(key: string): Promise<T | undefined>;
  }
}
