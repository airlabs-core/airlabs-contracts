import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JsonRpcProvider } from 'ethers';

export type Network = 'eth' | 'polygon';

@Injectable()
export class Web3Service {
  constructor(private readonly configService: ConfigService) {}

  getProvider(network: Network): JsonRpcProvider {
    return new JsonRpcProvider(this._getRpcUrl(network));
  }

  private _getRpcUrl(network: Network) {
    const networks = {
      eth: this.configService.get('MAINNET_JSON_RPC_URL'),
      polygon: this.configService.get('POLYGON_JSON_RPC_URL'),
    };
    return networks[network];
  }
}
