import { Module } from '@nestjs/common';
import { SignerService } from './signer.service';
import { Web3Module } from 'src/web3/web3.module';

@Module({
  imports: [Web3Module],
  providers: [SignerService],
  exports: [SignerService],
})
export class SignerModule {}
