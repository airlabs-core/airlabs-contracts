import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { Erc20Module } from './erc20/erc20.module';

@Module({
  imports: [Erc20Module],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
