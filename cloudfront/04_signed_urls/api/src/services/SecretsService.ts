import { SecretsManager } from "aws-sdk";

export class SecretsService implements AppTypes.Services.ISecretsService {
  constructor(private readonly client: SecretsManager) {}

  async get<T>(key: string): Promise<T | undefined> {
    try {
      const result = await this.client
        .getSecretValue({
          SecretId: key,
        })
        .promise();

      if (!result.SecretString) {
        return undefined;
      }

      return JSON.parse(result.SecretString) as T;
    } catch (error) {
      return undefined;
    }
  }
}
