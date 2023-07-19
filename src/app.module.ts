import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { Erc20Module } from './erc20/erc20.module';
import { ConfigModule } from '@nestjs/config';
import { SignerModule } from './signer/signer.module';

@Module({
  imports: [
    Erc20Module,
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    SignerModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
