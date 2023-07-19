import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { Erc20Module } from './erc20/erc20.module';
import { ConfigModule } from '@nestjs/config';
import { SignerModule } from './signer/signer.module';
import { Web3Module } from './web3/web3.module';
import { QuestModule } from './quest/quest.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    Erc20Module,
    SignerModule,
    Web3Module,
    QuestModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
