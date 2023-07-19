import { Module } from '@nestjs/common';
import { SignerService } from './signer.service';

@Module({
  providers: [SignerService],
})
export class SignerModule {}
