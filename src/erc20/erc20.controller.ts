import { Controller, Get, Param, Query } from '@nestjs/common';
import { Erc20Service } from './erc20.service';
import { Network } from 'src/web3/web3.service';

@Controller('erc20')
export class Erc20Controller {
  constructor(private readonly erc20Service: Erc20Service) {}

  @Get(':account/eq')
  eq(
    @Param('account') account: string,
    @Query('contractAddress') contractAddress: string,
    @Query('amount') amount: bigint,
    @Query('network') network: Network,
  ) {
    return this.erc20Service.eq(amount, { contractAddress, account, network });
  }

  @Get(':account/gte')
  gte(
    @Param('account') account: string,
    @Query('contractAddress') contractAddress: string,
    @Query('amount') amount: bigint,
    @Query('network') network: Network,
  ) {
    return this.erc20Service.gte(amount, { contractAddress, account, network });
  }

  @Get(':account/lte')
  lte(
    @Param('account') account: string,
    @Query('contractAddress') contractAddress: string,
    @Query('amount') amount: bigint,
    @Query('network') network: Network,
  ) {
    return this.erc20Service.lte(amount, { contractAddress, account, network });
  }
}
