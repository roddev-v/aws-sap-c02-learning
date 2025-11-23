export class GetSignedUrlCommand
  implements AppTypes.Commands.Command<void, { url: string }>
{
  constructor(
    private readonly secretsService: AppTypes.Services.ISecretsService
  ) {}

  async Run(): Promise<{ url: string }> {
    return { url: "" };
  }
}
