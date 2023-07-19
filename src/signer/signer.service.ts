import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JsonRpcProvider, Signer, Wallet } from 'ethers';

@Injectable()
export class SignerService {
  provider: JsonRpcProvider;
  signer: Signer;

  constructor(private readonly configService: ConfigService) {
    this.provider = new JsonRpcProvider(this.configService.get('JSON_RPC_URL'));
    this.signer = new Wallet(this.configService.get('VERIFIER_PRIVATE_KEY'));
  }
}
