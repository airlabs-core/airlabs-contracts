import { Module } from '@nestjs/common';
import { Erc20Service } from './erc20.service';
import { Erc20Controller } from './erc20.controller';
import { SignerModule } from 'src/signer/signer.module';
import { Web3Module } from 'src/web3/web3.module';

@Module({
  imports: [SignerModule, Web3Module],
  controllers: [Erc20Controller],
  providers: [Erc20Service],
})
export class Erc20Module {}
