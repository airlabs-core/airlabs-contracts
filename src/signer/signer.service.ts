import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Signer, Wallet } from 'ethers';
import { Network, Web3Service } from 'src/web3/web3.service';

@Injectable()
export class SignerService {
  constructor(
    private readonly configService: ConfigService,
    private readonly web3Service: Web3Service,
  ) {}

  public getSigner(network: Network): Signer {
    return new Wallet(
      this.configService.get('VERIFIER_PRIVATE_KEY'),
      this.web3Service.getProvider(network),
    );
  }
}
